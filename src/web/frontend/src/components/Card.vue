<template>
    <div>
        <p>name: {{ name }}</p>
        <p>players: {{ players }}</p>
        <p>seed: {{ seed }}</p>
        <p>max: {{ max }}</p>
        <p>online: {{ online }}</p>
    </div>
</template>

<script>
export default {
    name: 'Card',
    props: ['name', 'players', 'seed', 'max', 'online']
}
</script>
