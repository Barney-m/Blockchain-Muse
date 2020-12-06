import Vue from "vue";
import { ethers } from "ethers";
import MyGalleryContract from "../../../build/contracts/Muse.json";

const plugin = {
	install(Vue) {
		if (window.ethereum) {
			const provider = new ethers.providers.Web3Provider(window.ethereum);
			const signer = provider.getSigner();

			Vue.prototype.$contract = new ethers.Contract(
				MyGalleryContract.networks[5777].address,
				MyGalleryContract.abi,
				signer
			);
		}
	}
};

Vue.use(plugin);
