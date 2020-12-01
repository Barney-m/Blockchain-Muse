<template>
	<main id="app">
		<Header />
		<Home />
	</main>
</template>

<script>
import Header from "@/components/Header";
import Home from "@/view/Home";

export default {
	components: {
		Header,
		Home
	}
};
</script>
