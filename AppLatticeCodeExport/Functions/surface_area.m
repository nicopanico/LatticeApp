function area = surface_area(vertices, faces)
    tr = triangulation(faces, vertices);
    area = sum(triangleAreas(tr));
end