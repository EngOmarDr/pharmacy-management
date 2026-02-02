enum MedicineType {
  liquids('السوائل', 'Liquids', 'LIQ'),
  topical('الموضعية', 'Topical', 'TOP'),
  inhalers('المستنشقات', 'Inhalers', 'INH'),
  suppositories('التحاميل', 'Suppositories', 'SUP'),
  injections('الحقن', 'Injections', 'INJ'),
  drops('القطرات', 'Drops', 'DRO'),
  capsules('الكبسولات', 'Capsules', 'CAP'),
  tablets('اقراص', 'Tablets', 'TAB');

  final String nameAr;
  final String nameEn;
  final String value;

  const MedicineType(this.nameAr, this.nameEn, this.value);
}