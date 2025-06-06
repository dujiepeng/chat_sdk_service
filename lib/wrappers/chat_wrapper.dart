import '../chat_sdk_service.dart';
import 'package:flutter/foundation.dart';

mixin ChatWrapper on ChatUIKitServiceBase {
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.chatManager.addEventHandler(
      sdkEventKey,
      ChatEventHandler(
        onMessagesReceived: onMessagesReceived,
        onCmdMessagesReceived: onCmdMessagesReceived,
        onMessagesRead: onMessagesRead,
        onGroupMessageRead: onGroupMessageRead,
        onReadAckForGroupMessageUpdated: onReadAckForGroupMessageUpdated,
        onMessagesDelivered: onMessagesDelivered,
        onMessagesRecalled: onMessagesRecalled,
        onConversationsUpdate: onConversationsUpdate,
        onConversationRead: onConversationRead,
        onMessageReactionDidChange: onMessageReactionDidChange,
        onMessageContentChanged: onMessageContentChanged,
        onMessagePinChanged: onMessagePinChanged,
        onMessagesRecalledInfo: onMessagesRecalledInfo,
      ),
    );
  }

  @override
  void removeListeners() {
    super.removeListeners();
    Client.getInstance.chatManager.removeEventHandler(sdkEventKey);
  }

  @protected
  void onCmdMessagesReceived(List<Message> messages) {
    List<Message> list = [];
    for (var msg in messages) {
      if ((msg.body as CmdMessageBody).action == typingKey) {
        list.add(msg);
      }
    }
    if (list.isNotEmpty) {
      onTypingMessagesReceived(messages);
      messages.removeWhere((element) => list.contains(element));
    }

    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onCmdMessagesReceived(messages);
      }
    }
  }

  @protected
  void onMessagesRead(List<Message> messages) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessagesRead(messages);
      }
    }
  }

  @protected
  void onGroupMessageRead(List<GroupMessageAck> groupMessageAcks) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onGroupMessageRead(groupMessageAcks);
      }
    }
  }

  @protected
  void onReadAckForGroupMessageUpdated() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onReadAckForGroupMessageUpdated();
      }
    }
  }

  @protected
  void onMessagesDelivered(List<Message> messages) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessagesDelivered(messages);
      }
    }
  }

  @protected
  void onMessagesRecalled(List<Message> messages) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        // ignore: deprecated_member_use_from_same_package
        observer.onMessagesRecalled(messages);
      }
    }
  }

  @protected
  void onMessagesRecalledInfo(List<RecallMessageInfo> infos) {
    List<Message> replaces = [];
    for (var info in infos) {
      final replace = ChatUIKitInsertTools.insertRecallMessage(
        recalledMessage: info.recallMessage!,
        operatorId: info.recallBy,
      );
      replaces.add(replace);
    }
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessagesRecalledInfo(infos, replaces);
      }
    }
  }

  void onConversationsUpdate() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onConversationsUpdate();
      }
    }
  }

  @protected
  void onConversationRead(String from, String to) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onConversationRead(from, to);
      }
    }
  }

  @protected
  void onMessageReactionDidChange(List<MessageReactionEvent> events) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessageReactionDidChange(events);
      }
    }
  }

  @protected
  void onMessageContentChanged(
      Message message, String operatorId, int operationTime) async {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessageContentChanged(message, operatorId, operationTime);
      }
    }
  }

  @protected
  void onMessagesReceived(List<Message> messages) async {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessagesReceived(messages);
      }
    }
  }

  void onTypingMessagesReceived(List<Message> messages) {
    List<String> fromUsers = [];
    for (var msg in messages) {
      if (fromUsers.contains(msg.from)) continue;
      fromUsers.add(msg.from!);
    }
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onTyping(fromUsers);
      }
    }
  }

  void onMessagePinChanged(
    String messageId,
    String conversationId,
    MessagePinOperation pinOperation,
    MessagePinInfo pinInfo,
  ) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessagePinChanged(
            messageId, conversationId, pinOperation, pinInfo);
      }
    }
  }

  void onMessageUpdate(Message newMessage, [Message? oldMessage]) async {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessageUpdate(newMessage, oldMessage);
      }
    }
  }
}
