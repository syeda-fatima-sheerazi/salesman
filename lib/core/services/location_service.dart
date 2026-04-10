class LocationService {
  /// Returns dummy districts.
  Future<List<String>> fetchDistricts() async {
    // simulate network/db delay
    await Future.delayed(const Duration(milliseconds: 100));
    return ['Karachi', 'Lahore', 'Islamabad'];
  }

  /// Returns dummy towns keyed by district.
  Future<Map<String, List<String>>> fetchTowns() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return {
      'Karachi': ['Gulshan-e-Iqbal', 'Saddar', 'North Nazimabad'],
      'Lahore': ['Model Town', 'Gulberg'],
      'Islamabad': ['F-6', 'G-10'],
    };
  }

  /// Returns dummy areas keyed by town.
  Future<Map<String, List<String>>> fetchAreas() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return {
      'Gulshan-e-Iqbal': ['Block 1', 'Block 2'],
      'Saddar': ['Area A', 'Area B'],
      'North Nazimabad': ['Sector 1', 'Sector 2'],
      'Model Town': ['Zone 1'],
      'Gulberg': ['Zone A'],
      'F-6': ['Sector F6/1'],
      'G-10': ['Sector G10/2'],
    };
  }
}

