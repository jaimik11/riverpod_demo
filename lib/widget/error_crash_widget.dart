import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorCrashWidget extends StatelessWidget {
  final FlutterErrorDetails details;
  const ErrorCrashWidget(this.details, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Row(
          children: [
            Expanded(child: Text('Something unpredictable happened')),
            TextButton(onPressed: () => _onPressed(context), child: Text('Details')),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required Widget content,
    bool initiallyExpanded = false,
  }) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: content,
          ),
        ],
      ),
    );
  }

  void _onPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Error Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildExpandableSection(
                        title: 'Exception',
                        initiallyExpanded: true,
                        content: SelectableText(
                          details.exception.toString(),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.red,
                          ),
                        ),
                      ),
                      _buildExpandableSection(
                        title: 'Stack Trace',
                        content: SelectableText(
                          details.stack?.toString() ?? 'No stack trace available',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                      _buildExpandableSection(
                        title: 'Library',
                        content: SelectableText(
                          details.library ?? 'Unknown library',
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                      if (details.context != null)
                        _buildExpandableSection(
                          title: 'Context',
                          content: SelectableText(
                            details.context.toString(),
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      _buildExpandableSection(
                        title: 'Summary',
                        content: SelectableText(
                          details.summary.toString(),
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: details.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error details copied to clipboard'),
                    ),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Share Error Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
