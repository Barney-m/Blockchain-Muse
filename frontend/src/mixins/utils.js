export const utils = {
	methods: {
		handle(error) {
			const regex = /revert(.*)/;
			const match = regex.exec(error.data.message);

			this.$buefy.snackbar.open({
				duration: 0,
				message: match[1],
				type: "is-danger",
				position: "is-bottom",
				actionText: "OK"
			});
		}
	}
};
