import * as React from "react";
import Box from "@mui/material/Box";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import CardMedia from "@mui/material/CardMedia";
import Typography from "@mui/material/Typography";

export default function DriverCard({driver}) {
  return (
    <Card sx={{ display: "flex", cursor: "pointer" }} >
      <CardMedia
        component="img"
        sx={{ width: 150, height: 170 }}
        image="driver.jpg"
        alt="Live from space album cover"
      />
      <Box sx={{ display: "flex", flexDirection: "column" }}>
        <CardContent sx={{ flex: "1 0 auto" }}>
          <Typography component="div" fontSize={"19px"}>
            {driver.fullName}
          </Typography>
          <Typography
            variant="subtitle1"
            component="div"
            sx={{ color: "text.secondary" }}
          >
            {driver.contactNo}
          </Typography>
        </CardContent>
        <Box sx={{ display: "flex", alignItems: "center", pl: 2, pb: 2 }}>
          <Typography component="div" variant="h8">
            NIC No: {driver.nicNo}
          </Typography>
        </Box>
      </Box>
    </Card>
  );
}
