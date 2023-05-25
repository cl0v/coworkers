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
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
            children: [
          const Text("Nome do canil"),
          TextFormField(controller: nameController),
          const Text("Telefone"),
          TextFormField(controller: phoneController),
          const Text("Instagram"),
          TextFormField(controller: instagramController),
          const Text("CEP"),
          TextFormField(controller: cepController),
          const Text("Endereço"),
          TextFormField(controller: addressController),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                final AddStoreUseCase useCase = AddStoreUseCaseImpl(
                    repository: StoreRepositoryImpl(
                        FirestoreStoreImpl(FirebaseFirestore.instance)));
                final id = await useCase(Store(
                    nameController.text,
                    phoneController.text,
                    instagramController.text,
                    addressController.text,
                    cepController.text));

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

                // Fluttertoast.showToast(
                //   msg: "O id do canil é $id",
                //   timeInSecForIosWeb: 10,
                //   toastLength: Toast.LENGTH_LONG,
                //   gravity: ToastGravity.BOTTOM,
                // );
                formKey.currentState!.reset();
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
