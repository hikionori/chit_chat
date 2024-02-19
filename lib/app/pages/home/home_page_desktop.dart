import 'package:chit_chat/app/blocs/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePageDesktop extends StatefulWidget {
  const HomePageDesktop({super.key});

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  List<Message> messages = [
    Message(
      text: 'Hello, how can I help you?',
      sender: 'ai',
      time: '10:00',
    ),
    Message(
      text: 'I need help with my account',
      sender: 'user',
      time: '10:01',
    ),
    Message(
      text: 'Sure, what do you need help with?',
      sender: 'ai',
      time: '10:02',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
          child: Stack(
        children: [
          // side bar
          // at the side bar list of previews chats
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 270,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 3,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  top: BorderSide(
                    width: 3,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  bottom: BorderSide(
                    width: 3,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // button for new chat
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 230,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.plus,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'New Chat',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // list of chats
                  Positioned(
                      top: 70,
                      left: 0,
                      right: 0,
                      bottom: 140,
                      child: SizedBox(
                        width: 270,
                        height: MediaQuery.of(context).size.height - 130,
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('Chat $index'),
                              subtitle: Text('Last message'),
                              leading: CircleAvatar(
                                child: Text('A'),
                              ),
                            );
                          },
                        ),
                      )),

                  // buttons for logout and change theme
                  Positioned(
                    height: 140,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        // button for change theme
                        BlocBuilder<ThemeCubit, ThemeMode>(
                          builder: (context, state) {
                            return InkWell(
                              onTap: () {
                                context.read<ThemeCubit>().toggleTheme();
                              },
                              child: Container(
                                width: 230,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        state == ThemeMode.light
                                            ? FontAwesomeIcons.solidMoon
                                            : FontAwesomeIcons.solidSun,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Change Theme',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // button for logout
                        InkWell(
                          onTap: () async {
                            await Supabase.instance.client.auth.signOut();
                            GoRouter.of(context).go('/auth');
                          },
                          child: Container(
                            width: 230,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Theme.of(context).colorScheme.error,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.signOut,
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Logout',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onError,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // main content
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
                width: MediaQuery.of(context).size.width - 270,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    // list of messages
                    // at the top of the list of messages the name of the chat
                    // at the bottom of the list of messages the input field

                    // welcome message from chatbot
                    Positioned(
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        )),

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
                              // for file uploader
                              InkWell(
                                onTap: () {},
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
                                      border: Border.all(width: 3),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 21, vertical: 16),
                                    child: Center(
                                      child: TextField(
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
                              Container(
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
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.paperPlane,
                                    size: 20,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          )
          // bottom bar
        ],
      )),
    );
  }
}

class Message {
  final String text;
  final String sender;
  final String time;

  Message({
    required this.text,
    required this.sender,
    required this.time,
  });
}
