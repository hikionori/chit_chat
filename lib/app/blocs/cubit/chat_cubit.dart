import 'package:bloc/bloc.dart';
import 'package:chit_chat/app/models/message.dart';
import 'package:chit_chat/app/router.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  void sendMessage(String content) async {
    final messages = state is ChatInitial
        ? (state as ChatInitial).messages
        : state is ChatUpdated
            ? (state as ChatUpdated).messages
            : (state as ResponseLoaded).messages;
    messages.add(Message(role: "user", content: content));
    emit(ChatUpdated(messages));

    final jsonMessages = messages.map((e) => e.toJson()).toList();

    final response = await supabase.functions
        .invoke("chat", body: {"messages": jsonMessages});

    final responseMessages = response.data;
    messages
        .add(Message(role: "assistant", content: responseMessages["content"]!));
    emit(ResponseLoaded(messages));
    // Future.delayed(const Duration(seconds: 1), () {
    //   messages
    //       .add(Message(role: "assistant", content: "I'm a useful chat bot"));
    //   emit(ResponseLoaded(messages));
    // });
  }

  void closeChat() {
    emit(ChatInitial());
  }
}
