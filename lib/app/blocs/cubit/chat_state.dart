part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {
  final String? chatId = null;
  final List<Message>? messages = null;
}

final class ChatLoading extends ChatState {
  final String? chatId = null;
  final List<Message>? messages = null;
}

final class ChatLoaded extends ChatState {
  final String? chatId;
  final List<Message>? messages;

  const ChatLoaded({required this.chatId, required this.messages});
}
