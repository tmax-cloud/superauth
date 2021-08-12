import React, {useEffect, useState} from "../_snowpack/pkg/react.js";
import {Label} from "../_snowpack/pkg/@patternfly/react-core.js";
export const AliasRendererComponent = ({
  name,
  containerId,
  filterType,
  adminClient,
  id
}) => {
  const [containerName, setContainerName] = useState("");
  useEffect(() => {
    if (filterType === "clients") {
      adminClient.clients.findOne({id: containerId}).then((client) => setContainerName(client.clientId));
    }
  }, [containerId]);
  if (filterType === "roles" || !containerName) {
    return /* @__PURE__ */ React.createElement(React.Fragment, null, name);
  }
  if (filterType === "clients" || containerName) {
    return /* @__PURE__ */ React.createElement(React.Fragment, null, containerId && /* @__PURE__ */ React.createElement(Label, {
      color: "blue",
      key: `label-${id}`
    }, containerName), " ", name);
  }
  return null;
};
