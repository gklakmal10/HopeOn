import * as React from "react";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import ListItemButton from "@mui/material/ListItemButton";
import ListItemText from "@mui/material/ListItemText";
import ListItemAvatar from "@mui/material/ListItemAvatar";
import Checkbox from "@mui/material/Checkbox";
import {
  Avatar,
  Button,
  Dialog,
  DialogActions,
  DialogTitle,
} from "@mui/material";

import AddIcon from "@mui/icons-material/Add";
import { findAllAssignable } from "../service/vehicleService";
import { assignVehicle } from "../service/studentService";

export default function AssignVehicleModel({ studentId }) {
  const [checked, setChecked] = React.useState(null);
  const [open, setOpen] = React.useState(false);
  const [vehicles, setVehicles] = React.useState([]);

  const handleClickOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);

  const handleToggle = (value) => () => {
    setChecked((prev) => (prev === value ? null : value));
    console.log(value);
  };

  const fetchUnAssign = async () => {
    await findAllAssignable()
      .then(({ data }) => {
        setVehicles(data.object);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  const saveAssignVehicle = async () => {
    await assignVehicle(checked, studentId)
      .then(({ data }) => {
        handleClose();
      })
      .catch((err) => {
        console.log(err);
      });
  };

  React.useEffect(() => {
    fetchUnAssign();
  }, []);

  return (
    <React.Fragment>
      <Button
        startIcon={<AddIcon />}
        variant="outlined"
        onClick={handleClickOpen}
        sx={{ width: "100%" }}
      >
        Assign Vehicle
      </Button>
      <Dialog
        open={open}
        onClose={handleClose}
        aria-labelledby="responsive-dialog-title"
        fullWidth={true}
      >
        <DialogTitle>{"Assign Vehicle to Student"}</DialogTitle>
        <List dense sx={{ width: "100%", bgcolor: "background.paper" }}>
          {vehicles.map((vehicle) => {
            const labelId = `checkbox-list-secondary-label-${vehicle.id}`;
            return (
              <ListItem
                key={vehicle.id}
                sx={{ p: "0.5rem" }}
                secondaryAction={
                  <Checkbox
                    edge="start"
                    onChange={handleToggle(vehicle.id)} // Save vehicle.id
                    checked={checked === vehicle.id} // Check if vehicle.id matches
                    inputProps={{ "aria-labelledby": labelId }}
                  />
                }
                disablePadding
              >
                <ListItemButton>
                  <ListItemAvatar>
                    <Avatar
                      alt={`Avatar n°${vehicle.id}`}
                      src={`/static/images/avatar/${vehicle.id}.jpg`}
                    />
                  </ListItemAvatar>
                  <div>
                    <ListItemText
                      id={labelId}
                      primary={`${vehicle.vehicleNo}`}
                    />
                    <ListItemText
                      id={labelId}
                      primary={`NIC : ${vehicle.brand + " - " + vehicle.model + ` (${vehicle.color} color ${vehicle.type})`}`}
                    />
                    <ListItemText
                      id={labelId}
                      primary={`Available Seat Count : ${vehicle.availableSeatCount}`}
                    />
                  </div>
                </ListItemButton>
              </ListItem>
            );
          })}
        </List>
        <DialogActions>
          <Button variant="contained" onClick={handleClose}>
            Cancel
          </Button>
          <Button
            variant="contained"
            color="success"
            onClick={saveAssignVehicle}
          >
            Assign
          </Button>
        </DialogActions>
      </Dialog>
    </React.Fragment>
  );
}
