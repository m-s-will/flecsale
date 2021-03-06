/*~--------------------------------------------------------------------------~*
 * Copyright (c) 2016 Los Alamos National Laboratory, LLC
 * All rights reserved
 *~--------------------------------------------------------------------------~*/

// user includes
#include "mesh/burton/burton_mesh_topology.h"
#include "mesh/burton/burton_triangle.h"


namespace ale {
namespace mesh {

// some type aliases
using burton_2d_triangle_t = burton_triangle_t<2>;
using burton_3d_triangle_t = burton_triangle_t<3>;

////////////////////////////////////////////////////////////////////////////////
// 2D triangle
////////////////////////////////////////////////////////////////////////////////

// the centroid
burton_2d_triangle_t::point_t burton_2d_triangle_t::centroid() const
{
  auto msh = static_cast<const burton_2d_mesh_topology_t *>(mesh()); 
  auto vs = msh->template entities<vertex_t::dimension, vertex_t::domain>(this);
  return geom::shapes::triangle<num_dimensions>::centroid( 
    vs[0]->coordinates(), vs[1]->coordinates(), vs[2]->coordinates() );
}

// the midpoint
burton_2d_triangle_t::point_t burton_2d_triangle_t::midpoint() const
{
  auto msh = static_cast<const burton_2d_mesh_topology_t *>(mesh()); 
  auto vs = msh->template entities<vertex_t::dimension, vertex_t::domain>(this);
  return geom::shapes::triangle<num_dimensions>::midpoint( 
    vs[0]->coordinates(), vs[1]->coordinates(), vs[2]->coordinates() );
}

// the area of the cell
burton_2d_triangle_t::real_t burton_2d_triangle_t::area() const
{
  auto msh = static_cast<const burton_2d_mesh_topology_t *>(mesh()); 
  auto vs = msh->template entities<vertex_t::dimension, vertex_t::domain>(this);
  return geom::shapes::triangle<num_dimensions>::area( 
    vs[0]->coordinates(), vs[1]->coordinates(), vs[2]->coordinates() );
}

// the minimum length in the cell
burton_2d_triangle_t::real_t burton_2d_triangle_t::min_length() const
{
  auto msh = static_cast<const burton_2d_mesh_topology_t *>(mesh()); 
  auto vs = msh->template entities<vertex_t::dimension, vertex_t::domain>(this);
  auto es = msh->template entities<edge_t::dimension, edge_t::domain>(this);
  // check the edges first
  auto eit = es.begin();
  auto min_length = (*eit)->length();
  std::for_each( ++eit, es.end(), [&](auto && e) 
                 { 
                   min_length = std::min( (*e)->length(), min_length );
                 });
  // return result
  return min_length;
}


////////////////////////////////////////////////////////////////////////////////
// 3D triangle
////////////////////////////////////////////////////////////////////////////////

// the centroid
burton_3d_triangle_t::point_t burton_3d_triangle_t::centroid() const
{
  auto msh = static_cast<const burton_3d_mesh_topology_t *>(mesh()); 
  auto vs = msh->template entities<vertex_t::dimension, vertex_t::domain>(this);
  return geom::shapes::triangle<num_dimensions>::centroid( 
    vs[0]->coordinates(), vs[1]->coordinates(), vs[2]->coordinates() );
}

// the midpoint
burton_3d_triangle_t::point_t burton_3d_triangle_t::midpoint() const
{
  auto msh = static_cast<const burton_3d_mesh_topology_t *>(mesh()); 
  auto vs = msh->template entities<vertex_t::dimension, vertex_t::domain>(this);
  return geom::shapes::triangle<num_dimensions>::midpoint( 
    vs[0]->coordinates(), vs[1]->coordinates(), vs[2]->coordinates() );
}

// the normal
burton_3d_triangle_t::vector_t burton_3d_triangle_t::normal() const
{
  auto msh = static_cast<const burton_3d_mesh_topology_t *>(mesh()); 
  auto vs = msh->template entities<vertex_t::dimension, vertex_t::domain>(this);
  return geom::shapes::triangle<num_dimensions>::normal( 
    vs[0]->coordinates(), vs[1]->coordinates(), vs[2]->coordinates() );
}

// the area of the cell
burton_3d_triangle_t::real_t burton_3d_triangle_t::area() const
{
  auto msh = static_cast<const burton_3d_mesh_topology_t *>(mesh()); 
  auto vs = msh->template entities<vertex_t::dimension, vertex_t::domain>(this);
  return geom::shapes::triangle<num_dimensions>::area( 
    vs[0]->coordinates(), vs[1]->coordinates(), vs[2]->coordinates() );
}

// the minimum length in the cell
burton_3d_triangle_t::real_t burton_3d_triangle_t::min_length() const
{
  auto msh = static_cast<const burton_3d_mesh_topology_t *>(mesh()); 
  auto vs = msh->template entities<vertex_t::dimension, vertex_t::domain>(this);
  auto es = msh->template entities<edge_t::dimension, edge_t::domain>(this);
  // check the edges first
  auto eit = es.begin();
  auto min_length = (*eit)->length();
  std::for_each( ++eit, es.end(), [&](auto && e) 
                 { 
                   min_length = std::min( (*e)->length(), min_length );
                 });
  // return result
  return min_length;
}

} // namespace 
} // namespace 
