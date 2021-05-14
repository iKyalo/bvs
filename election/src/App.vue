<template>
  <div
    id="app"
    style="
    padding-top: 50px;"
  >
    <Slide width="250" noOverlay :closeOnNavigation="true">
      <router-link style="color: #ffc400" to="/">Home</router-link>
      <router-link v-if="isLoggedIn()" style="color: #ffc400" to="/ballot">Ballot</router-link>
      <br class="line-breaker" />
      <router-link v-if="isLoggedIn()" style="color: #ffc400" to="/dashboard"
        >Dashboard</router-link
      >
      <br class="line-breaker" />
       <router-link v-if="!isLoggedIn()" style="color: #ffc400" to="/login"
        >Login</router-link
      >
      <router-link v-if="!isLoggedIn()" style="color: #ffc400" to="/register"
        >Register</router-link
      > 

      <div class="container">
         <b-button v-if="isLoggedIn()" block variant="danger" @click="logout"
          >Logout</b-button
        > 
      </div>
    </Slide>
    <router-view />
  </div>
</template>

<script>
import { Slide } from "vue-burger-menu"; // import the CSS transitions you wish to use, in this case we are using `Slide`

export default {
  name: "app",
  components: {
    Slide,
  },
  data() {
    return {
      loggedIn: false,
    };
  },

  methods: {
    isLoggedIn() {
      var email = localStorage.getItem("email");
      var uuid = localStorage.getItem("uuid");
      var token = localStorage.getItem("token");

      if (email && uuid && token) {
        this.loggedIn = true;
        return true;
      } else {
        this.loggedIn = false;
        return false;
      }
    },
    logout() {
      var router = this.$router;

      localStorage.removeItem("email");
      localStorage.removeItem("uuid");
      localStorage.removeItem("token");

      this.loggedIn = false;

      // window.location.reload();

      router.push("/");
      window.location.reload();
    },
  },
};
</script>

<style>
* {
  font-family: Sen;
}
#app {
  font-family: Sen, Helvetica, Arial, sans-serif;
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
</style>
