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
import { assignVehicle, findAllUnAssigned } from "../service/driverService";

export default function AssignDriverListModel({vehicleId}) {
  const [checked, setChecked] = React.useState(null); 
  const [open, setOpen] = React.useState(false);
  const [drivers, setDrivers] = React.useState([]);

  const handleClickOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);

  const handleToggle = (value) => () => {
    setChecked((prev) => (prev === value ? null : value)); 
    console.log(value)
  };

  const fetchUnAssign = async () => {
    await findAllUnAssigned()
      .then(({ data }) => {
        setDrivers(data.object);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  const saveAssignVehicle = async () => {
    await assignVehicle(vehicleId, checked).then(({data})=>{
        handleClose()
    }).catch((err)=>{
        console.log(err)
        handleClose();
    })
  }

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
        Assign Driver
      </Button>
      <Dialog
        open={open}
        onClose={handleClose}
        aria-labelledby="responsive-dialog-title"
        fullWidth={true}
      >
        <DialogTitle>{"Assign Driver to Vehicle"}</DialogTitle>
        <List dense sx={{ width: "100%", bgcolor: "background.paper" }}>
          {drivers.map((driver) => {
            const labelId = `checkbox-list-secondary-label-${driver.id}`;
            return (
              <ListItem
                key={driver.id}
                sx={{ p: "0.5rem" }}
                secondaryAction={
                  <Checkbox
                    edge="start"
                    onChange={handleToggle(driver.id)} // Save driver.id
                    checked={checked === driver.id} // Check if driver.id matches
                    inputProps={{ "aria-labelledby": labelId }}
                  />
                }
                disablePadding
              >
                <ListItemButton>
                  <ListItemAvatar>
                    <Avatar
                      alt={`Avatar n°${driver.id}`}
                      src={`/static/images/avatar/${driver.id}.jpg`}
                    />
                  </ListItemAvatar>
                  <div>
                    <ListItemText id={labelId} primary={`${driver.fullName}`} />
                    <ListItemText
                      id={labelId}
                      primary={`NIC : ${driver.nicNo}`}
                    />
                    <ListItemText
                      id={labelId}
                      primary={`Contact No : ${driver.contactNo}`}
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
