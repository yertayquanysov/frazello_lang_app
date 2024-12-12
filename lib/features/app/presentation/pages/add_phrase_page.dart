import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/add_phrase_bloc.dart';

class AddPhrasePage extends StatelessWidget {
  AddPhrasePage(this.languageId, {super.key});

  final int languageId;

  final frontTextController = TextEditingController();
  final backTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add phrase"),
      ),
      body: BlocConsumer(
        bloc: context.read<AddPhraseBloc>(),
        listener: (BuildContext context, state) {
          if (state is PhraseAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Added"),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProgressBar) {
            return const LinearProgressIndicator();
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: frontTextController,
                    maxLength: 50,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Enter phrase";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Front",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: backTextController,
                    maxLength: 50,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Enter phrase";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Back",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AddPhraseBloc>().add(
                              front: frontTextController.text,
                              back: backTextController.text,
                              languageId: languageId,
                            );

                        frontTextController.clear();
                        backTextController.clear();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Add",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
