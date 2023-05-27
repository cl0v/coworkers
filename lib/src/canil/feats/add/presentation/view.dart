import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coworkers/src/canil/_external/datasources/firestore_store.dart';
import 'package:coworkers/src/canil/_infra/repositories/store.dart';
import 'package:coworkers/src/canil/domain/entities/store.dart';
import 'package:coworkers/src/canil/feats/add/domain/usecases/add_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  String? breed;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool? isWhatsAppSameAsPhone = false;

  void onChanged(bool? value) {
    setState(() {
      isWhatsAppSameAsPhone = value;
    });
  }

  void clearForm() {
    breed = breedController.text;
    formKey.currentState!.reset();
    breedController.text = breed ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
            children: [
          const Text("Nome do canil"),
          TextFormField(controller: nameController),
          const Text("Raça"),
          TextFormField(controller: breedController),
          const Text("Telefone"),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
          ),
          CheckboxListTile.adaptive(
              value: isWhatsAppSameAsPhone, onChanged: onChanged),
          const Text("WhatsApp"),
          TextFormField(
            controller: whatsappController,
            enabled: !(isWhatsAppSameAsPhone ?? false),
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
                final id = await useCase(Store(
                  breedController.text,
                  nameController.text,
                  phoneController.text
                      .split(',')
                      .map<ContactInfo>((e) => ContactInfo(
                            value: e.trim(),
                          ))
                      .toList(),
                  ContactInfo(value: instagramController.text),
                  ContactInfo(
                      value: isWhatsAppSameAsPhone ?? false
                          ? phoneController.text
                          : whatsappController.text),
                  addressController.text,
                  cepController.text,
                  obsController.text,
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
    );
  }
}
