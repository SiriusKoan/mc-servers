<template>
    <div class="container">
        <div>
            <div class="label">
                <span>Name: </span>
                <span>{{ name }}</span>
            </div>
            <div class="label">
                <span>Seed: </span>
                <span>{{ seed }}</span>
            </div>
            <div class="label">
                <span>Status: </span>
                <span>{{ online }} / {{ max }}</span>
            </div>
            <div class="label">
                <span>Players: </span>
                <span v-for="player in players">{{ player }} </span>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: 'Card',
    props: ['name', 'players', 'seed', 'max', 'online']
}
</script>

<style>
.container {
    padding: 5px;
    margin: 10px;
    box-shadow: 0px 0px 6px 1px rgba(255,255,255,0.75);
    -webkit-box-shadow: 0px 0px 6px 1px rgba(255,255,255,0.75);
    -moz-box-shadow: 0px 0px 6px 1px rgba(255,255,255,0.75);
    width: 300px;
    height: 150px;
    border-radius: 7px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    border: 1px white solid;
    background-color: rgba(255, 255, 255, 0.2);
}

.container:hover {
    opacity: 0.8;
}

.label span:first-child {
    font-weight: bold;
}
</style>
