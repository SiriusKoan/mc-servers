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
            this.servers = Object.entries(res['data']);
            for (let i = 0; i < this.servers.length; i++) {
                if (this.servers[i][1]) {
                    axios
                    .get('/api/' + this.servers[i][0])
                    .then((res) => {
                        res['data']['status'] = 'active';
                        this.servers_info.push(res['data']);
                    })
                }
                else {
                    this.servers_info.push({
                        'status': 'inactive',
                        'name': this.servers[i][0]
                    });
                }
            }
        })
    }
}
</script>

<template>
  <h1>Minecraft Servers</h1>
  <main>
    <Card v-for="server in servers_info" :class="server.status" :status="server.status" :name="server.name" :players="server.players" :seed="server.seed" :max="server.max" :online="server.online" />
  </main>
  <footer>
      <Copyright />
  </footer>
</template>

<style>
@import "assets/base.css";
</style>
