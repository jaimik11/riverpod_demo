enum AppRoute {
  splash(path: '/splash', name: 'splash'),
  personalDetails(path: '/personalDetails', name: 'personalDetails');

  final String path;
  final String name;

  const AppRoute({required this.path, required this.name});

}