import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coworkers/src/store/_external/datasources/firestore_store.dart';
import 'package:coworkers/src/store/_infra/repositories/store.dart';
import 'package:coworkers/src/store/domain/entities/store.dart';
import 'package:coworkers/src/store/feats/add/domain/entities/create_store_result.dart';
import 'package:coworkers/src/store/feats/add/domain/usecases/add_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCanilPage extends StatefulWidget {
  const AddCanilPage({super.key});

  @override
  State<AddCanilPage> createState() => _AddCanilPageState();
}

final splitBySpecialsRegex = RegExp(r'[,/;]');

class _AddCanilPageState extends State<AddCanilPage> {
  final TextEditingController nameController =
      TextEditingController(
        // text: kDebugMode ? "Canil de teste" : ""
        );
  final TextEditingController phoneController =
      TextEditingController(
        // text: kDebugMode ? "00000000000, 2222222222" : ""
        );
  final TextEditingController whatsappController =
      TextEditingController(text: kDebugMode ? "11999999999" : "");
  final TextEditingController instagramController =
      TextEditingController(text: kDebugMode ? "canil_de_teste" : "");
  final TextEditingController breedController =
      TextEditingController(text: kDebugMode ? "Pug" : "");
  final TextEditingController cepController =
      TextEditingController(text: kDebugMode ? "00000000" : "");
  final TextEditingController addressController =
      TextEditingController(text: kDebugMode ? "Rua de teste, 123" : "");
  final TextEditingController obsController =
      TextEditingController(text: kDebugMode ? "Observação de teste" : "");

  String? breeds;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isWhatsAppSameAsPhone = false;

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
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
              children: [
            const Text("Nome do canil"),
            TextFormField(controller: nameController),
            const Text("Raças (Separe por vírgula)"),
            TextFormField(
              controller: breedController,
            ),
            const Text("Telefones, separados por vírgula (,)"),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
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
            TextFormField(controller: instagramController),
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
              child: const Text("Cadastrar"),
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
    final phones = phoneController.text
        .split(splitBySpecialsRegex)
        .map((e) => e.trim())
        .toList();

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

      switch (result.status) {
        case StoreCreationStatus.created:
          contentText = "Canil cadastrado com sucesso! ID: ${result.value}";
          labelButton = 'Copiar ID';
          onTap = () => onCopyToClipboard(result.value);
          hasButton = true;
          clearForm();
          break;
        case StoreCreationStatus.error:
          contentText = result.message ?? "Erro ao cadastrar canil";
          labelButton = 'Tentar novamente';
          onTap = () => onRetry(store);
          break;
        case StoreCreationStatus.duplicated:
          contentText = result.message ??
              "Canil já cadastrado, gostaria de editar os valores?";
          labelButton = 'Editar';
          onTap = () => onEdit(result.value);
          break;
        default:
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(contentText),
        duration: const Duration(seconds: 10),
        backgroundColor: Colors.red,
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

  Future<CreateStoreResult> create(Store store) async {
    final AddStoreUseCase useCase = AddStoreUseCaseImpl(
        repository: StoreRepositoryImpl(
            FirestoreStoreImpl(FirebaseFirestore.instance)));

    return await useCase(store);
  }

  void onRetry(Store store) {}

  void onEdit(Store store) {
    nameController.text = store.name;
  }
}
