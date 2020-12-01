<template>
	<section>
		<h2 class="subtitle">Add New Song</h2>
		<div>
			<b-field label="Title">
				<b-input v-model.trim="title"></b-input>
			</b-field>

			<b-field label="Author">
				<b-input v-model.trim="author"></b-input>
			</b-field>

			<span class="is-size-6">Song Category:</span>
			<div class="block category-btns">
				<b-radio v-model="category" name="category" native-value="0">Pop</b-radio>
				<b-radio v-model="category" name="category" native-value="1">Indie</b-radio>
				<b-radio v-model="category" name="category" native-value="2">Rock</b-radio>
				<b-radio v-model="category" name="category" native-value="3"
					>HipHop</b-radio
				>
				<b-radio v-model="category" name="category" native-value="4">Mood</b-radio>
				<b-radio v-model="category" name="category" native-value="5">Chill</b-radio>
				<b-radio v-model="category" name="category" native-value="6">RnB</b-radio>
				<b-radio v-model="category" name="category" native-value="7"
					>Romance</b-radio
				>
				<b-radio v-model="category" name="category" native-value="8">Jazz</b-radio>
				<b-radio v-model="category" name="category" native-value="9">Anime</b-radio>
			</div>

			<b-button type="is-primary is-medium" expanded @click="addSong()"
				>Add Song</b-button
			>
		</div>
	</section>
</template>

<script>
import { utils } from "@/mixins/utils.js";

export default {
	mixins: [utils],

	data() {
		return {
			title: "",
			author: "",
			category: 2
		};
	},

	methods: {
		async addSong() {
			try {
				const ismn = this.newISMN();
				await this.$contract.addSong(this.title, this.author, this.category, ismn);

				this.onAddSong({
					title: this.title,
					author: this.author,
					category: this.category,
					ismn: ismn,
					available: true
				});
			} catch (error) {
				this.handle(error);
			}
		},

		newISMN() {
			return Math.floor(1000000000000 + Math.random() * 9000000000000);
		},

		onAddSong(song) {
			this.title = "";
			this.author = "";
			this.category = 2;

			this.$emit("onAddSong", { name: "onAddSong", data: song });
		}
	}
};
</script>

<style scoped>
.category-btns {
	padding-top: 10px;
}
</style>
