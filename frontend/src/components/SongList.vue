<template>
	<section>
		<h2 class="subtitle">Number of Songs: {{ songCount }}</h2>
		<b-table :data="songs">
			<template slot-scope="props">
				<b-table-column field="song.title" label="Title">{{
					props.row.title
				}}</b-table-column>

				<b-table-column field="song.author" label="Author">{{
					props.row.author
				}}</b-table-column>

				<b-table-column field="song.link" label="Link">{{
					props.row.link
				}}</b-table-column>

				<b-table-column field="song.passcode" label="Passcode">{{
					props.row.passcode
				}}</b-table-column>

				<b-table-column field="user.category" label="Category" centered>
					<span v-if="props.row.category == 0">Pop</span>
					<span v-else-if="props.row.category == 1">Indie</span>
					<span v-else-if="props.row.category == 2">Rock</span>
					<span v-else-if="props.row.category == 3">HipHop</span>
					<span v-else-if="props.row.category == 4">Mood</span>
					<span v-else-if="props.row.category == 5">Chill</span>
					<span v-else-if="props.row.category == 6">RnB</span>
					<span v-else-if="props.row.category == 7">Romance</span>
					<span v-else-if="props.row.category == 8">Jazz</span>
					<span v-else>Anime</span>
				</b-table-column>

				<b-table-column field="user.ismn" label="ISMN" numeric>{{
					props.row.ismn
				}}</b-table-column>

				<b-table-column field="user.available" label="Available" centered>
					<b-icon
						pack="fas"
						:type="props.row.available === true ? 'is-success' : 'is-danger'"
						:icon="props.row.available === true ? 'check' : 'times'"
					></b-icon>
				</b-table-column>

				<b-table-column label="Actions">
					<div class="buttons">
						<b-button
							v-if="props.row.available"
							type="is-primary"
							@click="issueSong(props.row.ismn)"
							>Buy</b-button
						>
						<b-button v-else type="is-info" @click="returnSong(props.row.ismn)"
							>Return</b-button
						>
						<b-button type="is-danger" @click="deleteSong(props.row.ismn)"
							>Delete</b-button
						>
					</div>
				</b-table-column>
			</template>

			<template slot="empty">
				<section class="section">
					<div class="content has-text-grey has-text-centered">
						<p>
							<b-icon pack="fas" icon="frown" size="is-large"></b-icon>
						</p>
						<p>Nothing here.</p>
					</div>
				</section>
			</template>
		</b-table>
	</section>
</template>

<script>
export default {
	props: ["songs", "songCount"],

	methods: {
		async issueSong(ismn) {
			await this.$contract.issueSong(ismn);
			this.emitHandler("onIssueSong", ismn);
		},

		async returnSong(ismn) {
			await this.$contract.returnSong(ismn);
			this.emitHandler("onReturnSong", ismn);
		},

		async deleteSong(ismn) {
			await this.$contract.deleteSong(ismn);
			this.emitHandler("onDeleteSong", ismn);
		},

		emitHandler(name, data) {
			this.$emit(name, { name, data });
		}
	}
};
</script>
