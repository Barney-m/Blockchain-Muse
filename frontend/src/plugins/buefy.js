import Vue from "vue";
import Buefy from "buefy";
import "buefy/dist/buefy.css";

import { library } from "@fortawesome/fontawesome-svg-core";
import { faCheck, faTimes, faFrown } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";

library.add(faCheck, faTimes, faFrown);

Vue.component("vue-fontawesome", FontAwesomeIcon);

Vue.use(Buefy, {
	defaultIconComponent: "vue-fontawesome",
	defaultIconPack: "fas"
});
