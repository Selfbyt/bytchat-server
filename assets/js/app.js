// assets/js/app.js
let socket = new Socket("/socket", {params: {token: "<%= @conn |> get_session(:user_token) %>"}})
socket.connect()

let channel = socket.channel("chat:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("message", payload => {
  let chat = document.getElementById("chat");
  let messageItem = document.createElement("li");
  messageItem.innerText = `${payload.user}: ${payload.content}`;
  chat.appendChild(messageItem);
})

document.getElementById("message-form").addEventListener("submit", event => {
  event.preventDefault();
  let messageInput = document.getElementById("message");

  channel.push("message", {
    content: messageInput.value,
  });

  messageInput.value = "";
});