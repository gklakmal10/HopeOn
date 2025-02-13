import * as React from "react";
import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid2";
import DriverCard from "../../components/DriverCard";
import { findAllDrivers } from "../../service/driverService";

// const drivers = [
//   {
//     nicNo: "123456",
//     fullName: "Chamath Goonetilleke",
//     contactNo: "0788564256",
//     gender: "Male",
//     age: "15",
//     experience: "10 years",
//     location: "Kesbewa Junction",
//     imageUrl: "",
//   },
//   {
//     nicNo: "123456",
//     fullName: "Chamath Goonetilleke",
//     contactNo: "0788564256",
//     gender: "Male",
//     age: "15",
//     experience: "10 years",
//     location: "Kesbewa Junction",
//     imageUrl: "",
//   },
//   {
//     nicNo: "123456",
//     fullName: "Chamath Goonetilleke",
//     contactNo: "0788564256",
//     gender: "Male",
//     age: "15",
//     experience: "10 years",
//     location: "Kesbewa Junction",
//     imageUrl: "",
//   },
//   {
//     nicNo: "123456",
//     fullName: "Chamath Goonetilleke",
//     contactNo: "0788564256",
//     gender: "Male",
//     age: "15",
//     experience: "10 years",
//     location: "Kesbewa Junction",
//     imageUrl: "",
//   },
// ];

export default function DriversGrid({
  setIsDriverSelected,
  setSelectedDriver,
  setFetchAllDrivers,
}) {
  const [drivers, setDrivers] = React.useState([]);
  const [loading, setLoading] = React.useState(false);

  const fetchAllDrivers = async () => {
    setLoading(true);
    await findAllDrivers()
      .then(({ data }) => {
        setDrivers(data.object);
        setLoading(false);
      })
      .catch((err) => {
        console.log(err);
        setLoading(false);
      });
  };

  React.useEffect(() => {
    fetchAllDrivers();
    setFetchAllDrivers(() => fetchAllDrivers);
  }, [setFetchAllDrivers]);
  return (
    <Box sx={{ flexGrow: 1 }}>
      <Grid
        container
        spacing={{ xs: 2, md: 3 }}
        columns={{ xs: 7, sm: 9, md: 12 }}
      >
        {drivers.map((driver, index) => (
          <Grid key={index} size={{ xs: 3, sm: 4, md: 4 }}>
            <div
              onClick={() => {
                setSelectedDriver(driver);
                setIsDriverSelected(true);
              }}
            >
              <DriverCard driver={driver} />
            </div>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
}
