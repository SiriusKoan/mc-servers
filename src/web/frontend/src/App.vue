<script>
import Card from './components/Card.vue'
import Copyright from './components/Copyright.vue'
export default {
    data() {
        return {
            messages: {},
            status: {},
            show: {},
            commands: {},
            servers: null,
            //servers_info: [{"name": "1"}, {"name": "2"}, {"name": "3"}, {"name": "4"}, {"name": "5"}]
            servers_info: []
        }
    },
    components: {
        Card,
        Copyright
    },
    methods: {
        update(data, name) {
            let f = false;
            for (let i = 0; i < this.servers_info.length; i++) {
                if (this.servers_info[i]['name'] == name) {
                    this.servers_info[i] = data;
                    f = true;
                    break;
                }
            }
            if (!f) {
                this.servers_info.push(data);
            }
        },
        updateData() {
            axios
            .get('/api/all')
            .then((res) => {
                this.servers = Object.entries(res['data']);
                for (let i = 0; i < this.servers.length; i++) {
                    let data = {};
                    let name = this.servers[i][0];
                    if (this.servers[i][1]) {
                        axios
                        .get(`/api/${this.servers[i][0]}`)
                        .then((res) => {
                            res['data']['status'] = 'active';
                            data = res['data'];
                            this.update(data, name);
                        })
                    }
                    else {
                        data = {
                            'status': 'inactive',
                            'name': name
                        }
                        this.update(data, name);
                    }
                }
            })
        },
        sendCommand(server_name) {
            axios
            .post(`/api/${server_name}`, {
                'command': this.commands[server_name]
            })
            .then((res) => {
                this.status[server_name] = 'success';
                this.messages[server_name] = res['data'];
            })
            .catch((err) => {
                this.status[server_name] = 'error';
                this.messages[server_name] = err['response']['data'];
            })
        },
        updateCommand(server_name, command) {
            this.commands[server_name] = command;
        }
    },
    mounted() {
        this.updateData();
        window.setInterval(() => {
            this.updateData();
            //console.log('update');
        }, 2000);
    }
}
</script>

<template>
  <h1>Minecraft Servers</h1>
  <main>
      <Card 
      v-for="server in servers_info"
      v-bind="{ server }"
      :class="server.status"
      :message="messages[server.name]"
      :status="status[server.name]"
      :show_players="show[server.name]"
      :command="commands[server.name]"
      @send="sendCommand"
      @over="show[server.name]=true"
      @leave="show[server.name]=false"
      @input="updateCommand" />
  </main>
  <footer>
      <Copyright />
  </footer>
</template>

<style>
@import "assets/base.css";
</style>
