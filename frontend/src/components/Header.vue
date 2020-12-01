<template>
	<header class="hero is-primary">
		<div class="hero-body">
			<div class="container">
				<h1 class="title">Muse DApp</h1>
				<h2 class="subtitle">Ether.js + Vue</h2>
				<b-button @click="connect" type="is-warning">Connect to Site</b-button>
			</div>
		</div>
	</header>
</template>

<script>
export default {
	methods: {
		async connect() {
			await window.ethereum.request({ method: "eth_requestAccounts" });
		}
	}
};
</script>
