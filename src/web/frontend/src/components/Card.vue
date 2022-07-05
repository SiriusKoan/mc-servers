<template>
    <div class="container">
        <div>
            <div class="label">
                <span>Name: </span>
                <span>{{ server.name }}</span>
            </div>
            <div class="label" v-if="server.status === 'inactive'">
                <span>Status: </span>
                <span>{{ server.status }}</span>
            </div>
            <div v-if="server.status === 'active'">
                <div class="label">
                    <span>Seed: </span>
                    <span>{{ server.seed }}</span>
                </div>
                <div class="label">
                    <span>Online: </span>
                    <span>{{ server.online }} / {{ server.max }}</span>
                </div>
                <div class="label players" @mouseover="sendMouseOverSignal" @mouseleave="sendMouseLeaveSignal">
                    <div>Players</div>
                    <div v-for="player in server.players" v-if="show_players">{{ player }} </div>
                </div>
                <hr>
                <div class="command">
                    <input type="text" placeholder="/command" v-model="command">
                    <button @click="sendCommandSignal">Send</button>
                </div>
                <div class="message" :class="status">
                    <span>&#62; </span>
                    <span>{{ message }}</span>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: 'Card',
    props: {
        server: null,
        command: String,
        message: String,
        status: String,
        show_players: Boolean
    },
    methods: {
        sendCommandSignal() {
            this.$emit('send', this.server.name, this.command);
        },
        sendMouseOverSignal() {
            this.$emit('over');
        },
        sendMouseLeaveSignal() {
            this.$emit('leave');
        }
    }
}
</script>

<style>
@import "../assets/input.css";

hr {
    margin-top: 3px;
    margin-bottom: 3px;
}

.container {
    padding: 5px;
    margin: 10px;
    box-shadow: 0px 0px 6px 1px rgba(255,255,255,0.75);
    -webkit-box-shadow: 0px 0px 6px 1px rgba(255,255,255,0.75);
    -moz-box-shadow: 0px 0px 6px 1px rgba(255,255,255,0.75);
    width: 330px;
    height: 220px;
    border-radius: 7px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    border: 1px white solid;
}

.label > *:first-child {
    font-weight: bold;
}

.players div:not(:first-child) {
    width: 200px;
    position: fixed;
    z-index: 100;
    color: black;
    background-color: rgb(255, 255, 255);
    padding: 3px;
}

.players {
    width: fit-content;
}

.players div:first-child {
    cursor: pointer;
}

.players div:first-child:after {
    content: '▼';
    display: inline-block;
}

.active {
    background-color: rgba(255, 255, 255, 0.2);
}

.inactive {
    background-color: rgba(0, 0, 0, 0.6);
    opacity: 0.5;
}

.command input {
    font-family: Consolas;
}

.message {
    word-wrap: break-word;
    width: 250px;
    color: white;
    display: block;
    margin: 5px auto;
    padding: 5px;
    border: 1px solid white;
    background-color: rgba(0, 0, 0, 0.4);
    font-family: Consolas;
    font-size: 12px;
}

.message span:first-child {
    user-select: none;
}

.success span:first-child {
    color: #04AA6D;
}

.error span:first-child {
    color: #f44336;
}
</style>
