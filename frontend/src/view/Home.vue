<template>
	<section class="section">
		<div class="container is-fluid">
			<div class="columns">
				<AddSongForm @onAddSong="updateSongList" class="column is-one-third" />
			</div>
			<div>
				<SongList
					@onIssueSong="updateSongList"
					@onReturnSong="updateSongList"
					@onDeleteSong="updateSongList"
					class="column"
					:songs="songs"
					:song-count="songCount"
				/>
			</div>
		</div>
		<div></div>
	</section>
</template>

<script>
import SongList from "@/components/SongList";
import AddSongForm from "@/components/AddSongForm";
import { utils } from "@/mixins/utils";

export default {
	components: {
		SongList,
		AddSongForm
	},

	mixins: [utils],

	data() {
		return {
			songs: [],
			songCount: 0
		};
	},

	async created() {
		await Promise.all([this.getCreatedSongs(), this.getSongCount()]);
	},

	methods: {
		async getAllSongs() {
			try {
				const result = await this.$contract.getAllSongs();

				this.songs = result.map((song) => {
					return {
						title: song.title,
						author: song.author,
						category: song.category,
						ismn: song.ismn,
						link: song.link,
						passcode: song.passcode,
						available: song.available
					};
				});
			} catch (error) {
				this.handle(error);
			}
		},

		async getSongCount() {
			this.songCount = await this.$contract.getSongCount();
		},

		async getCreatedSongs() {
			try {
				const result = await this.$contract.getCreatedSongs();

				this.songs = result.map((song) => {
					return {
						title: song.title,
						author: song.author,
						category: song.category,
						ismn: song.ismn,
						link: song.link,
						passcode: song.passcode,
						available: song.available
					};
				});
			} catch (error) {
				this.handle(error);
			}
		},

		updateSongList(event) {
			switch (event.name) {
				case "onAddSong": {
					this.songs.push(event.data);
					this.songCount++;
					break;
				}
				case "onIssueSong": {
					const songIdx = this.findSongIndex(event.data);
					this.songs[songIdx].available = false;
					break;
				}
				case "onReturnSong": {
					const songIdx = this.findSongIndex(event.data);
					this.songs[songIdx].available = true;
					break;
				}
				case "onDeleteSong": {
					const songIdx = this.findSongIndex(event.data);
					this.songs.splice(songIdx, 1);
					this.songCount--;
					break;
				}
			}
		},

		findSongIndex(ismn) {
			return this.songs.findIndex((song) => song.ismn === ismn);
		}
	}
};
</script>
