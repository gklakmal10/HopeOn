import React from "react";
import GradesAndClassesTable from "../../components/GradesAndClassesTable";
import AddGradeModal from "../../components/AddGradeModal";

export default function GradesAndClasses() {
  const [fetchDataFunction, setFetchDataFunction] = React.useState(
    () => () => {}
  );

  return (
    <div>
      <div
        style={{
          display: "flex",
          justifyContent: "flex-end",
          marginBottom: "1rem",
        }}
      >
        <AddGradeModal fetchAllGradeClasses={fetchDataFunction} />
      </div>
      <GradesAndClassesTable setFetchDataFunction={setFetchDataFunction} />
    </div>
  );
}
