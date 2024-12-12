import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frazello/core/services/audio_player.dart';
import 'package:frazello/core/services/text2speech_service.dart';
import 'package:frazello/features/app/data/repositories/audio_generate_repository.dart';
import 'package:frazello/features/app/data/repositories/language_list_repository.dart';
import 'package:frazello/features/app/data/repositories/phrase_repository.dart';
import 'package:frazello/features/app/presentation/bloc/language_bloc.dart';
import 'package:frazello/features/app/presentation/bloc/phrase_list_bloc.dart';
import 'package:frazello/features/app/presentation/bloc/review_phrase_bloc.dart';
import 'package:frazello/features/app/presentation/pages/authentication_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config.dart';
import 'features/app/presentation/bloc/add_phrase_bloc.dart';
import 'features/app/presentation/pages/language_list_page.dart';

final logger = Logger();

void main() async {
  await Supabase.initialize(
    url: Config.supabaseUrl,
    anonKey: Config.supabaseApiKey,
  );

  final supabaseClient = Supabase.instance.client;
  final supabaseStorage = supabaseClient.storage;

  final text2speechService = Text2SpeechServiceImpl();
  final phrasePlayer = PhrasePlayerImpl();

  // Repositories
  final languageListRepository = LanguageListRepositoryImpl(supabaseClient);
  final phraseRepository = PhraseRepositoryImpl(
    supabaseClient,
    supabaseStorage,
  );

  final audioGenerateRepository = AudioGenerateRepositoryImpl(
    phraseRepository,
    supabaseStorage,
    text2speechService,
  );

  // BLoС List
  final languageBloc = LanguageBloc(languageListRepository);
  final reviewPhraseBloc = ReviewPhraseBloc(phrasePlayer, phraseRepository);
  final phraseListBloc = PhraseListBloc(phraseRepository);
  final addPhraseBloc = AddPhraseBloc(phraseRepository, phraseListBloc);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => languageBloc),
        BlocProvider(create: (_) => addPhraseBloc),
        BlocProvider(create: (_) => phraseListBloc),
        BlocProvider(create: (_) => reviewPhraseBloc),
        RepositoryProvider(create: (_) => audioGenerateRepository),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.ubuntuTextTheme(),
        ),
        home: Builder(
          builder: (_) {
            if (supabaseClient.auth.currentUser == null) {
              return AuthenticationPage();
            }

            return const LanguageListPage();
          },
        ),
      ),
    ),
  );
}
