import * as React from "react";
import Box from "@mui/material/Box";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import CardMedia from "@mui/material/CardMedia";
import Typography from "@mui/material/Typography";

export default function VehicleCard({vehicle}) {
  return (
    <Card sx={{ display: "flex", cursor: "pointer" }} >
      <CardMedia
        component="img"
        sx={{ width: 150, height: 170 }}
        image="vehicle.jpg"
        alt="Live from space album cover"
      />
      <Box sx={{ display: "flex", flexDirection: "column" }}>
        <CardContent sx={{ flex: "1 0 auto" }}>
          <Typography component="div" variant="h6">
            {vehicle.vehicleNo}
          </Typography>
          <Typography
            variant="subtitle1"
            component="div"
            sx={{ color: "text.secondary" }}
          >
            {vehicle.brand+" - "+vehicle.model+ ` (${vehicle.color})`}
          </Typography>
        </CardContent>
        <Box sx={{ display: "flex", alignItems: "center", pl: 2, pb: 2 }}>
          <Typography component="div" variant="h8">
            {vehicle.route}
          </Typography>
        </Box>
      </Box>
    </Card>
  );
}
