import 'dart:io';

import 'package:chit_chat/app/blocs/cubit/chat_cubit.dart';
import 'package:chit_chat/app/blocs/cubit/theme_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPageMobile extends StatefulWidget {
  const ChatPageMobile({super.key});

  @override
  State<ChatPageMobile> createState() => _ChatPageMobileState();
}

class _ChatPageMobileState extends State<ChatPageMobile> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Theme Switcher
          // new chat button
          // logout button
          IconButton(
            onPressed: () {
              // change theme
              BlocProvider.of<ThemeCubit>(context).toggleTheme();
            },
            icon: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) {
                return Icon(
                  state == ThemeMode.dark
                      ? FontAwesomeIcons.solidMoon
                      : FontAwesomeIcons.solidSun,
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              BlocProvider.of<ChatCubit>(context).closeChat();
            },
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
          IconButton(
            onPressed: () {
              // sign out
              Supabase.instance.client.auth.signOut();
              context.go('/auth');
            },
            icon: const FaIcon(FontAwesomeIcons.signOutAlt),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
            child: Stack(
          children: [
            // messages
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatInitial) {
                    return Positioned(
                      // center
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,

                      child: Column(
                        children: [
                          // image
                          Image.asset('assets/images/mid_logo.png',
                              height: 200, width: 200),
                          const SizedBox(height: 20),
                          // text
                          Text(
                            'Welcome to Chit Chat',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    fontFamily: 'FixelDisplay',
                                    fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ChatUpdated || state is ResponseLoaded) {
                    final messages = state is ChatUpdated
                        ? state.messages
                        : (state as ResponseLoaded).messages;

                    return Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 80,
                      child: ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isChatbotMessage = message.role == 'assistant';
                          final isUserMessage = message.role == 'user';
                          final isSystemMessage = message.role == 'system';

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: isChatbotMessage
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                if (isChatbotMessage)
                                  Container(
                                    width: 40,
                                    height: 40,
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
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                const SizedBox(
                                  width: 10,
                                ),
                                if (!isSystemMessage) // Exclude system messages
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width -
                                              200,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 12),
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
                                    width: 40,
                                    height: 40,
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
                                        size: 20,
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
                    return Positioned(
                      // center
                      left: 0,
                      right: 0,
                      bottom: 0,

                      child: Column(
                        children: [
                          // image
                          Image.asset('assets/images/mid_logo.png',
                              height: 200, width: 200),
                          const SizedBox(height: 20),
                          // text
                          Text(
                            'Welcome to Chit Chat',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    fontFamily: 'FixelDisplay',
                                    fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ), // input
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 80,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    // button for send file
                    InkWell(
                      onTap: () {
                        FilePicker.platform.pickFiles(
                            allowedExtensions: ["pdf"]).then((value) async {
                          if (value != null) {
                            final file = File(value.files.single.path ?? '');

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
                          color: Theme.of(context).colorScheme.primaryContainer,
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
                    // input field
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 140,
                      height: 50,
                      child: Expanded(
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
                                controller: _messageController,
                                keyboardType: TextInputType.text,
                                style: Theme.of(context).textTheme.labelSmall,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Type a message',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .labelSmall
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
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // button for send message
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<ChatCubit>(context)
                            .sendMessage(_messageController.text);
                        _messageController.clear();
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
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.paperPlane,
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
                  ],
                ))
          ],
        )),
      ),
    );
  }
}
