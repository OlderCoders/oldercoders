import Axios from "axios";
import "controllers";
import "config";
import "styles";
import "scripts";
import "components";

// require("channels");

// Add Rails' CSRF token header to XHRs
Axios.defaults.headers.common["X-CSRF-Token"] = document
  .querySelector('meta[name="csrf-token"]')
  .getAttribute("content");
