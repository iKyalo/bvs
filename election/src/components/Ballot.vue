<template>
  <div v-if="isDrizzleInitialized">
    <h1>Ballot</h1>
    <hr />
    <div class="ballot_list">
      <br />
    </div>
    <h2>Candidates:</h2>

    <div v-for="(name, i) in getNames" :key="i" class="div-wrap">
      <b-card
        :title="splitNameForName(utils.toUtf8(name))"
        :img-src="'/img/' + splitNameForPhoto(utils.toUtf8(name))"
        :img-alt="splitNameForName(utils.toUtf8(name)) + ' photo'"
        :img-height="'250px'"
        img-top
        tag="article"
        style="max-width: 25rem; border-radius: 20px; "
        class="mb-2"
      >
        <!-- <b-card-text>{{ splitNameForPos(utils.toUtf8(name)) }}</b-card-text> -->

        <b-button
          block
          variant="primary"
          @click="onSubmit(i, splitNameForName(utils.toUtf8(name)))"
        >
          Vote
          <i class="fas fa-vote-yea"></i>
        </b-button>

        <!-- <pre>{{ ballot_voted }}</pre> -->
        <!-- <pre>{{ cands_voted }}</pre> -->
      </b-card>
    </div>
  </div>
  <div v-else>
    Loading application...
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import Swal from "sweetalert2";

export default {
  name: "app",
  data() {
    return {
      dropdown_text: "C",
      ethData: {},
      names: [],
      filtered_names: [],
    };
  },
  computed: {
    ...mapGetters("drizzle", ["drizzleInstance", "isDrizzleInitialized"]),
    ...mapGetters("contracts", ["getContractData"]),
    getNames() {
      let data = this.getContractData({
        contract: "Election",
        method: "getNames",
      });
      if (data === "loading") return false;

      return data;
    },
    hasUserVoted() {
      let data = this.getContractData({
        contract: "Election",
        method: "findUserVote",
      });
      if (data === "loading") return false;

      return data;
    },

    utils() {
      return this.drizzleInstance.web3.utils;
    },
  },
  methods: {
    onSubmit(i, name) {
      console.log(i + " " + name);

      if (this.hasUserVoted) {
        Swal.fire({
          icon: "error",
          title: "Error",
          text: "You have already voted!",
        });
      } else {
        Swal.fire({
          title: "Confirm vote for " + name,
          text: "This process is final and irreversible.",
          icon: "warning",
          showCancelButton: true,
          confirmButtonColor: "#3085d6",
          cancelButtonColor: "#d33",
          confirmButtonText: "Confirm",
        }).then((result) => {
          if (result.isConfirmed) {
            this.drizzleInstance.contracts["Election"].methods[
              "vote"
            ].cacheSend(i);
            //   Swal.fire("Voted!", "Your vote has been placed", "success");
          }
        });
      }
    },
    candidateType(type) {
      console.log(type);
      this.dropdown_text = type;

      let data = this.getContractData({
        contract: "Election",
        method: "getNames",
      });
      if (data === "loading") return false;

      this.names = data;

      let ob = [];

      this.names.forEach((el) => {
        let n = this.utils.toUtf8(el);
        let sn = this.splitNameForPos(n);
        if (sn === type) {
          // ob.push(n);
          this.$set(this.filtered_names, this.filtered_names.length - 1, n);
          // this.$set();
        }
      });

      this.filtered_names = ob;

      console.log(this.filtered_names);
    },
    splitNameForName(name) {
      let _name = name.split(",");
      let cand_name = _name[0];
      //let cand_pos = _name[1];
      //let cand_photo = _name[2];

      return cand_name;
    },
    splitNameForPos(name) {
      let _name = name.split(",");
      //let cand_name = _name[0];
      let cand_pos = _name[1];
      //let cand_photo = _name[2];

      return cand_pos;
    },
    splitNameForPhoto(name) {
      let _name = name.split(",");
      //let cand_name = _name[0];
      //let cand_pos = _name[1];
      let cand_photo = _name[2];

      return cand_photo;
    },
  },
  created() {
    this.$store.dispatch("drizzle/REGISTER_CONTRACT", {
      contractName: "Election",
      method: "getNames",
      methodArgs: [],
    });

    this.$store.dispatch("drizzle/REGISTER_CONTRACT", {
      contractName: "Election",
      method: "findUserVote",
      methodArgs: [],
    });
  },
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}

.div-wrap {
  margin: 10px;
}
</style>
