import React, { useState } from "react";
import SingleVehiclePage from "./SingleVehiclePage";
import VehicleGrid from "./VehicleGrid";
import AddVehicleModal from "../../components/AddVehicleModal";

export default function VehicleManagementPage() {
  const [isVehicleSelected, setIsVehicleSelected] = React.useState(false);
  const [selectedVehicle, setSelectedVehicle] = React.useState(null);
  const [fetchAllVehicles, setFetchAllVehicles] = useState(() => () => {});
  
  if (isVehicleSelected === true) {
    return (
      <SingleVehiclePage
        vehicleDate={selectedVehicle}
        setIsVehicleSelected={setIsVehicleSelected}
        setSelectedVehicle={setSelectedVehicle}
      />
    );
  } else {
    return (
      <div style={{ margin: "1rem" }}>
        <div
          style={{
            display: "flex",
            justifyContent: "flex-end",
            padding: "1rem",
          }}
        >
          <AddVehicleModal fetchAllVehicles={fetchAllVehicles} />
        </div>
        <VehicleGrid
          setIsVehicleSelected={setIsVehicleSelected}
          setSelectedVehicle={setSelectedVehicle}
          setFetchAllVehicles={setFetchAllVehicles}
        />
      </div>
    );
  }
}
