<?php

namespace App\Repository;

use App\Entity\Post;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;
use Knp\Component\Pager\Pagination\PaginationInterface;
use Knp\Component\Pager\PaginatorInterface;

/**
 * @extends ServiceEntityRepository<Post>
 */
class PostRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry, private PaginatorInterface $paginator)
    {
        parent::__construct($registry, Post::class);
    }

    /**
     * @return PaginationInterface<int, mixed>
     */
    public function findAllPaginate(int $page): PaginationInterface
    {
        return $this->paginator->paginate($this->findAll(), $page);
    }

    /**
     * @return array<Post>
     */
    public function findLatest(): array
    {
        $qb = $this->createQueryBuilder('p')
            ->where('p.publishedAt <= :now')
            ->orderBy('p.publishedAt', 'DESC')
            ->setMaxResults(5)
            ->setParameter('now', new \DateTimeImmutable());

        return $qb->getQuery()->getResult();
    }
}
