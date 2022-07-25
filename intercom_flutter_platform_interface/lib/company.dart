/// The Company class is used for adding companies to users in Intercom.
/// You can use [updateUser] method for that.
///
/// All of the fields are optional.

class Company {
  final String? id;
  final String? name;
  final Map<String, dynamic>? customAttributes;
  final DateTime? createdAt;
  final int? monthlySpend;
  final String? plan;

  Company({
    this.id,
    this.name,
    this.customAttributes,
    this.createdAt,
    this.monthlySpend,
    this.plan,
  });
}

Map<String, dynamic> mapToNativeParameters(Company company) {
  return {
    'id': company.id,
    'name': company.name,
    'customAttributes': company.customAttributes,
    'createdAt': company.createdAt?.millisecondsSinceEpoch,
    'monthlySpend': company.monthlySpend,
    'plan': company.plan,
  };
}
