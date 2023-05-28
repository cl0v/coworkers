import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coworkers/src/canil/_external/datasources/firestore_store.dart';
import 'package:coworkers/src/canil/_infra/repositories/store.dart';
import 'package:coworkers/src/canil/domain/entities/store.dart';
import 'package:coworkers/src/canil/feats/add/domain/usecases/add_store.dart';
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
      TextEditingController(text: kDebugMode ? "Canil de teste" : "");
  final TextEditingController phoneController =
      TextEditingController(text: kDebugMode ? "00000000000, 2222222222" : "");
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
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  final AddStoreUseCase useCase = AddStoreUseCaseImpl(
                      repository: StoreRepositoryImpl(
                          FirestoreStoreImpl(FirebaseFirestore.instance)));

                  final phones =
                      phoneController.text.split(splitBySpecialsRegex).map((e) => e.trim()).toList();
                  final id = await useCase(Store(
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
                  ));

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('O id do canil é $id'),
                      duration: const Duration(seconds: 10),
                      backgroundColor: Colors.red,
                      action: SnackBarAction(
                          backgroundColor: Colors.blue,
                          label: 'Copiar ID',
                          textColor: Colors.white,
                          onPressed: () async =>
                              await Clipboard.setData(ClipboardData(text: id))),
                    ));
                  }
                  clearForm();
                },
                child: const Text("Cadastrar")),
          ]
                  .map((e) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8), child: e))
                  .toList()),
        ),
      ),
    );
  }
}
