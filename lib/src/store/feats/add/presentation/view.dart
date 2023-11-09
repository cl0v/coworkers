import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coworkers/src/store/_external/datasources/firestore_store.dart';
import 'package:coworkers/src/store/_infra/repositories/store.dart';
import 'package:coworkers/src/store/domain/entities/store.dart';
import 'package:coworkers/src/store/feats/add/domain/entities/create_store_result.dart';
import 'package:coworkers/src/store/feats/add/domain/usecases/add_store.dart';
import 'package:coworkers/src/store/feats/add/domain/usecases/check_instagram_duplication.dart';
import 'package:coworkers/src/store/feats/add/domain/usecases/split_phone.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../utils/regex.dart';
import '../domain/usecases/check_phones_duplication.dart';

enum _FieldValitation { instagram, phone }

class AddCanilPage extends StatefulWidget {
  const AddCanilPage({super.key});

  @override
  State<AddCanilPage> createState() => _AddCanilPageState();
}

class _AddCanilPageState extends State<AddCanilPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController obsController = TextEditingController();

  String? breeds;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isWhatsAppSameAsPhone = false;

  var phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final repository =
      StoreRepositoryImpl(FirestoreStoreImpl(FirebaseFirestore.instance));

  void onChanged(bool? value) {
    setState(() {
      isWhatsAppSameAsPhone = value ?? isWhatsAppSameAsPhone;
    });
  }

  void onCopyToClipboard(String id) {
    Clipboard.setData(ClipboardData(text: id));
  }

  void clearForm() {
    breeds = breedController.text;
    formKey.currentState!.reset();
    breedController.text = breeds ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => formKey.currentState!.reset(),
        label: const Text("Limpar formulario"),
        icon: const Icon(Icons.delete),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Telefones, separados por vírgula (,)"),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [phoneMaskFormatter],
                  onChanged: (value) =>
                      checkDuplication(_FieldValitation.phone, value),
                ),
                CheckboxListTile.adaptive(
                  title: const Text(
                      "WhatsApp é o mesmo que o primeiro telefone da lista?"),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: isWhatsAppSameAsPhone,
                  onChanged: onChanged,
                ),
                const Text("WhatsApp para negócios"),
                TextFormField(
                  controller: whatsappController,
                  enabled: !(isWhatsAppSameAsPhone),
                ),
                const Text("Instagram"),
                TextFormField(
                  controller: instagramController,
                  onChanged: (value) =>
                      checkDuplication(_FieldValitation.instagram, value),
                ),
                const Text("Nome do canil"),
                TextFormField(controller: nameController),
                const Text("Raças (Separe por vírgula)"),
                TextFormField(
                  controller: breedController,
                ),
                const Text("CEP"),
                TextFormField(
                  controller: cepController,
                  keyboardType: TextInputType.number,
                ),
                const Text("Endereço"),
                TextFormField(controller: addressController),
                const Text("Observações"),
                TextFormField(
                  controller: obsController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira pelo menos o site que você encontrou o canil';
                    }
                    return null;
                  },
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText:
                        'Site, observações, possiveis problemas e alertas, etc.',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: onCreateTapped,
                  child: const SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: Center(child: Text("Cadastrar")),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
              ]
                  .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: e))
                  .toList()),
        ),
      ),
    );
  }

  Future<void> onCreateTapped() async {
    final phones = SplitPhone(phoneController.text).call();

    final Store store = Store(
      breeds: breedController.text
          .split(splitBySpecialsRegex)
          .map((e) => e.trim())
          .toList(),
      name: nameController.text,
      contact: ContactInfo(
        phones: phones,
        isWhatsAppSameAsPhone: isWhatsAppSameAsPhone,
        whatsapp: whatsappController.text,
        instagram: instagramController.text,
      ),
      address: addressController.text,
      cep: cepController.text,
      obs: obsController.text,
    );

    final result = await create(store);

    if (context.mounted) {
      late String contentText;
      late String labelButton;
      late void Function() onTap;
      bool hasButton = false;
      Color snackColor = Colors.green;

      switch (result.status) {
        case StoreCreationStatus.created:
          contentText = "Canil cadastrado com sucesso! ID: ${result.value}";
          labelButton = 'Copiar ID';
          onTap = () => onCopyToClipboard(result.value);
          hasButton = true;
          clearForm();
          break;
        case StoreCreationStatus.error:
          contentText = result.message ?? "Ocorreu um erro ao cadastrar canil";
          labelButton = 'Tentar novamente';
          onTap = () => onRetry(store);
          snackColor = Colors.red;
          break;
        case StoreCreationStatus.duplicated:
          contentText = result.message ?? "Canil já cadastrado.";
          labelButton = 'Revisar e Editar';
          snackColor = Colors.orange;
          onTap = () => onEdit(result.value);
          break;
        default:
      }
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(contentText),
        duration: const Duration(seconds: 6),
        backgroundColor: snackColor,
        action: hasButton
            ? SnackBarAction(
                backgroundColor: Colors.blue,
                label: labelButton,
                textColor: Colors.white,
                onPressed: onTap,
              )
            : null,
      ));
    }
  }

  checkDuplication(_FieldValitation field, String value) async {
    switch (field) {
      case _FieldValitation.instagram:
        if (value.isEmpty) {
          return;
        } else if (value.length < 4) {
          return;
        } else {
          CheckInstagramDuplicationUseCase usecase =
              CheckInstagramDuplicationUseCaseImpl(repository);
          final result = await usecase(value);
          if (result != null && context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(result),
              duration: const Duration(seconds: 6),
              backgroundColor: Colors.red,
            ));
          }
        }
        break;
      case _FieldValitation.phone:
        if (value.isEmpty) {
          return;
        } else if (value.length < "3398525199".length) {
          return;
        } else {
          CheckPhonesDuplicationUseCase usecase =
              CheckPhonesDuplicationUseCaseImpl(repository);
          final result = await usecase(value);
          if (result != null && context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(result),
              duration: const Duration(seconds: 6),
              backgroundColor: Colors.red,
            ));
          }
        }
        break;
      default:
    }
  }

  Future<CreateStoreResult> create(Store store) async {
    final AddStoreUseCase useCase = AddStoreUseCaseImpl(repository: repository);

    return await useCase(store);
  }

  void onRetry(Store store) {}

  void onEdit(Store store) {
    nameController.text = store.name;
  }
}
