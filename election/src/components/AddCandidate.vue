<template>
  <div v-if="isDrizzleInitialized" class="div1">
    <h1>Add New Candidate</h1>

    <drizzle-contract-form
      contractName="Election"
      method="addName"
      :placeholders="['Name, Position, Photo']"
    />
  </div>
  <div v-else>
    Loading application...
  </div>
</template>

<script>
import { mapGetters } from "vuex";
export default {
  name: "app",
  data() {
    return {
      ethData: {},
      names: [],
      filtered_names: [],
    };
  },
  computed: {
    ...mapGetters("drizzle", ["drizzleInstance", "isDrizzleInitialized"]),
    ...mapGetters("contracts", ["getContractData"]),

    utils() {
      return this.drizzleInstance.web3.utils;
    },
  },
  methods: {},
  created() {},
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

.div1 {
  padding-top: 30px;
  padding-left: 20px;
  padding-right: 20px;
}
</style>
