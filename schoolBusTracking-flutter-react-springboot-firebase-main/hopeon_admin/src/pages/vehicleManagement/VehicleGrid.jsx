import * as React from "react";
import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid2";
import VehicleCard from "../../components/VehicleCard";
import { findAllVehicles } from "../../service/vehicleService";

export default function VehicleGrid({
  setIsVehicleSelected,
  setSelectedVehicle,
  setFetchAllVehicles,
}) {
  const [vehicles, setVehicles] = React.useState([]);

  const fetchAllVehicles = async () => {
    await findAllVehicles()
      .then(({ data }) => {
        setVehicles(data.object);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  React.useEffect(() => {
    fetchAllVehicles();
    setFetchAllVehicles(()=>fetchAllVehicles)
  }, [setFetchAllVehicles]);

  return (
    <Box sx={{ flexGrow: 1 }}>
      <Grid
        container
        spacing={{ xs: 2, md: 3 }}
        columns={{ xs: 7, sm: 9, md: 12 }}
      >
        {vehicles.map((vehicle, index) => (
          <Grid key={index} size={{ xs: 3, sm: 4, md: 4 }}>
            <div
              onClick={() => {
                setSelectedVehicle(vehicle);
                setIsVehicleSelected(true);
              }}
            >
              <VehicleCard vehicle={vehicle} />
            </div>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
}
