# Grand Challenge: Real-time Analysis of Social Networks Leveraging the Flink Framework

In this paper, we present a solution to the DEBS 2016 Grand Challenge that leverages Apache Flink, an open source platform for distributed stream and batch processing. The challenge focuses on the real-time analysis of an evolving social-network graph, to (1) determine the posts that trigger the current most activity, and (2) identify large communities that are currently involved in a topic.

We design the system architecture focusing on the exploitation of parallelism and memory efficiency so to enable an effective processing of high volume data streams on a distributed infrastructure.

Our solution to the first query relies on a distributed and fine-grain approach for updating the post scores and determining partial ranks, which are then merged into a single final rank. Furthermore, changes in the final rank are efficiently identified so to update the output only if needed.

The second query efficiently represents in-memory the evolving social graph and uses a customized Bron-Kerbosch algorithm to identify the largest communities active on a topic. We leverage on an in-memory caching system to keep the largest connected components which have been previously identified by the algorithm, thus saving computational time.

We run the experiments on a single node equipped with 4 cores and 8 GB of RAM. For a medium dataset size with 200k events, our system can process up to 2.5(?) kEvents/s with an average latency of 0.4(?) ms for the first query, and up to 2.8(?) kEvents/s with an average latency of 0.5(?) ms for the second query.


## Authors
Giacomo Marciani [gmarciani@acm.org](mailto:gmarciani@acm.org)

Marco Piu [pyumarco@gmail.com](mailto:pyumarco@gmail.com)

Michele Porretta [micheleporretta@gmail.com](mailto:micheleporretta@gmail.com)

Matteo Nardelli [nardelli@ing.uniroma2.it](mailto:nardelli@ing.uniroma2.it)

Valeria Cardellini [cardellini@ing.uniroma2.it](mailto:cardellini@ing.uniroma2.it)


## Institution
Department of Civil Engineering and Computer Science Engineering, University of Rome Tor Vergata, Italy


## License
The paper is released under the [BSD License](https://opensource.org/licenses/BSD-3-Clause).
Please, read the file LICENSE.md for details.
