<script>
import Card from './components/Card.vue'
export default {
    data() {
        return {
            servers: null,
            servers_info: []
        }
    },
    components: {
        Card
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
  <header>
      <p>test</p>
  </header>

  <main>
      <p>{{ servers }}</p>
      <Card v-for="server in servers_info" :name="server.name" :players="server.players" :seed="server.seed" :max="server.max" :online="server.online" />
  </main>
</template>

<style>
</style>
