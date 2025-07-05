<?php

namespace App\Repository;

use App\Entity\Tag;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\ORM\QueryBuilder;
use Doctrine\Persistence\ManagerRegistry;
use Symfony\Component\Uid\Uuid;

/**
 * @extends ServiceEntityRepository<Tag>
 */
class TagRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Tag::class);
    }

    /**
     * @return array<string, array{t_id: Uuid, t_name: string, p_count: int}>
     */
    public function findAllWithPostsCount(): array
    {
        $qb = $this->createQueryBuilder('t');
        static::addPostsCount($qb);
        static::orderByTagNameAsc($qb);

        return $qb->getQuery()->getScalarResult();
    }

    protected static function addPostsCount(QueryBuilder $qb): void
    {
        $qb
            ->leftJoin('t.posts', 'p')
            ->addSelect('COUNT(t.id) as p_count')
            ->groupBy('t.id');
    }

    protected static function orderByTagNameAsc(QueryBuilder $qb): void
    {
        $qb->orderBy('t.name', 'ASC');
    }
}
