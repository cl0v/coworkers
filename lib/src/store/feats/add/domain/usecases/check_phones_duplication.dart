import '../../../../../utils/regex.dart';
import '../../../../_infra/repositories/store.dart';

abstract class CheckPhonesDuplicationUseCase{
  Future<String?> call(String phones);
}

class CheckPhonesDuplicationUseCaseImpl implements CheckPhonesDuplicationUseCase{
  final StoreRepository repository;

  CheckPhonesDuplicationUseCaseImpl(this.repository);

  @override
  Future<String?> call(phones) async {
    final List<String> list = phones.split(splitBySpecialsRegex)
        .map((e) => e.trim())
        .toList();

    final result = await repository.checkPhonesDuplication(list);
    return result?.message;
  }
}