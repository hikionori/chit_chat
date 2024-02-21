part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {
  final messages = <Message>[
    Message(role: "system", content: "You are useful chat bot")
  ];

  @override
  List<Object> get props => [messages];
}

final class ChatUpdated extends ChatState {
  final List<Message> messages;

  const ChatUpdated(this.messages);

  @override
  List<Object> get props => [messages];
}

final class ResponseLoaded extends ChatState {
  final List<Message> messages;

  const ResponseLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}
