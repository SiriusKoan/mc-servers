<script>
import Card from './components/Card.vue'
import Copyright from './components/Copyright.vue'
export default {
    data() {
        return {
            servers: null,
            //servers_info: [{"name": "1"}, {"name": "2"}, {"name": "3"}, {"name": "4"}, {"name": "5"}]
            servers_info: []
        }
    },
    components: {
        Card,
        Copyright
    },
    mounted() {
        axios
        .get('/api/all')
        .then((res) => {
            this.servers = res['data'];
            for (let i = 0; i < this.servers.length; i++) {
                axios
                .get('/api/' + this.servers[i])
                .then((res) => {
                    this.servers_info.push(res['data']);
                })
            }
        })
    }
}
</script>

<template>
  <h1>Minecraft Servers</h1>
  <main>
    <Card v-for="server in servers_info" :name="server.name" :players="server.players" :seed="server.seed" :max="server.max" :online="server.online" />
  </main>
  <footer>
      <Copyright />
  </footer>
</template>

<style>
@import "assets/base.css";
</style>
