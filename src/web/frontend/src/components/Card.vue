<template>
    <div class="container">
        <div>
            <div class="label">
                <span>Name: </span>
                <span>{{ server.name }}</span>
            </div>
            <div class="label">
                <span>Status: </span>
                <span>{{ server.status }}</span>
            </div>
            <div v-if="server.status === 'active'">
                <div class="label">
                    <span>Seed: </span>
                    <span>{{ server.seed }}</span>
                </div>
                <div class="label">
                    <span>Status: </span>
                    <span>{{ server.online }} / {{ server.max }}</span>
                </div>
                <div class="label">
                    <span>Players: </span>
                    <span v-for="player in server.players">{{ player }} </span>
                </div>
                <div class="label">
                    <input type="text" placeholder="Command" v-model="command">
                    <button @click="sendCommandSignal">Send</button>
                </div>
                <div class="message" v-if="message" :class="status">
                    {{ message }}
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
        status: String
    },
    methods: {
        sendCommandSignal() {
            this.$emit('send', this.server.name, this.command);
        }
    }
}
</script>

<style>
.container {
    padding: 5px;
    margin: 10px;
    box-shadow: 0px 0px 6px 1px rgba(255,255,255,0.75);
    -webkit-box-shadow: 0px 0px 6px 1px rgba(255,255,255,0.75);
    -moz-box-shadow: 0px 0px 6px 1px rgba(255,255,255,0.75);
    width: 330px;
    height: 170px;
    border-radius: 7px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    border: 1px white solid;
}

.label span:first-child {
    font-weight: bold;
}

.active {
    background-color: rgba(255, 255, 255, 0.2);
}

.inactive {
    background-color: rgba(0, 0, 0, 0.6);
    opacity: 0.5;
}

.message {
    color: white;
    display: block;
    margin: 10px auto;
	padding: 20px;
	box-shadow: 3px 2px 10px 1px rgba(0, 0, 0, 0.3);
}

.success {
    background-color: #04AA6D;
}

.error {
    background-color: #f44336;
}
</style>
