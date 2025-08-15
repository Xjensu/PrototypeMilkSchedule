import consumer from "./consumer"

consumer.subscriptions.create("TransferScheduleChannel", {
  connected() {
    console.log("Connected to TransferScheduleChannel")
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log("Disconnected from TransferScheduleChannel")
    // Called when the subscription has been terminated by the server
  },

  received(data) {
     console.log("Received data:", data)
    // Called when there's incoming data on the websocket for this channel
  }
});
