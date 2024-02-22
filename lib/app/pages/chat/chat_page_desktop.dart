import 'dart:io';

import 'package:chit_chat/app/blocs/cubit/chat_cubit.dart';
import 'package:chit_chat/app/blocs/cubit/theme_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPageDesktop extends StatefulWidget {
  const ChatPageDesktop({super.key});

  @override
  State<ChatPageDesktop> createState() => _ChatPageDesktopState();
}

class _ChatPageDesktopState extends State<ChatPageDesktop> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
          child: Stack(
        children: [
          // main content
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 270,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  // list of messages
                  // at the top of the list of messages the name of the chat
                  // at the bottom of the list of messages the input field

                  // welcome message from chatbot or messages
                  BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
                    // print the state
                    // print(state);

                    if (state is ChatInitial) {
                      return const Welcome();
                    }

                    if (state is ChatUpdated || state is ResponseLoaded) {
                      final messages = state is ChatUpdated
                          ? (state).messages
                          : (state as ResponseLoaded).messages;

                      return Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 80,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final isChatbotMessage =
                                message.role == 'assistant';
                            final isUserMessage = message.role == 'user';
                            final isSystemMessage = message.role == 'system';

                            // display messages in listview
                            // on the left side for chatbot messages
                            // on the right side for user messages
                            // system message are don't displayed
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 21, vertical: 10),
                              child: Row(
                                mainAxisAlignment: isChatbotMessage
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                                children: [
                                  if (isChatbotMessage)
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.robot,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                  // display loading indicator
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  if (!isSystemMessage) // Exclude system messages
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width -
                                                300,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 21, vertical: 16),
                                      decoration: BoxDecoration(
                                        color: isChatbotMessage
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primaryContainer
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        message.content,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                    ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  if (isUserMessage)
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.user,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Welcome();
                    }
                  }),

                  // input field
                  Positioned(
                    height: 60,
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 270,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 21),
                        child: Row(
                          children: [
                            // logout button
                            InkWell(
                              onTap: () async {
                                // sign out
                                await Supabase.instance.client.auth.signOut();
                                context.go('/auth');
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.signOutAlt,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            // button for closing the chat
                            InkWell(
                              onTap: () {
                                BlocProvider.of<ChatCubit>(context).closeChat();
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.times,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            InkWell(
                              onTap: () {
                                // change theme
                                BlocProvider.of<ThemeCubit>(context)
                                    .toggleTheme();
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: Center(
                                  child: FaIcon(
                                    BlocProvider.of<ThemeCubit>(context)
                                                .state ==
                                            ThemeMode.light
                                        ? FontAwesomeIcons.solidMoon
                                        : FontAwesomeIcons.solidSun,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            // for file uploader
                            InkWell(
                              onTap: () {
                                FilePicker.platform
                                    .pickFiles(allowedExtensions: ['pdf']).then(
                                        (value) async {
                                  if (value != null) {
                                    final file =
                                        File(value.files.single.path ?? '');

                                    // generate a random file name
                                    final filePath = file.path;
                                    final response = await Supabase
                                        .instance.client.storage
                                        .from("files")
                                        .upload(
                                            'chat/${DateTime.now().millisecondsSinceEpoch}-${filePath.split('/').last}',
                                            file);
                                    print(response);
                                  }
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.paperclip,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 21, vertical: 16),
                                  child: Center(
                                    child: TextField(
                                      controller: _textController,
                                      keyboardType: TextInputType.text,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'Type a message',
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<ChatCubit>(context)
                                    .sendMessage(_textController.text);
                                setState(() {
                                  _textController.clear();
                                  // scroll to the bottom of the list of messages
                                  // _scrollController.jumpTo(_scrollController
                                  //         .position.maxScrollExtent +
                                  //     200);
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.paperPlane,
                                    size: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ), // bottom bar
        ],
      )),
    );
  }
}

class Welcome extends StatelessWidget {
  const Welcome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 70,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/mid_logo.png'),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 400,
                child: Text(
                  textAlign: TextAlign.center,
                  'Hi, What do you want to discuss today?',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
        ));
  }
}
